package br.com.cardosofiles.v2_internet_programming.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import br.com.cardosofiles.v2_internet_programming.model.Client;
import br.com.cardosofiles.v2_internet_programming.model.Contato;
import br.com.cardosofiles.v2_internet_programming.model.Email;
import br.com.cardosofiles.v2_internet_programming.model.Endereco;
import br.com.cardosofiles.v2_internet_programming.service.ClientService;

@Controller
@RequestMapping("/clientes")
public class ClientController {

    @Autowired
    private ClientService clientService;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("clientes", clientService.listarTodos());
        return "listar";
    }

    @GetMapping("/novo")
    public String novo(Model model) {
        Client client = new Client();
        client.getContatos().add(new Contato());
        client.getEmails().add(new Email());
        client.setEndereco(new Endereco());
        model.addAttribute("cliente", client);
        return "form";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model, RedirectAttributes redirect) {
        return clientService.buscarPorId(id).map(client -> {
            model.addAttribute("cliente", client);
            return "form";
        }).orElseGet(() -> {
            redirect.addFlashAttribute("erro", "Cliente não encontrado");
            return "redirect:/clientes";
        });
    }

    @PostMapping("/salvar")
    public String salvar(@RequestParam(required = false) Long id, @RequestParam String nome,
            @RequestParam String cpf, @RequestParam String dataNascimento,
            @RequestParam(value = "contato[]") String[] contatos,
            @RequestParam(value = "tipoContato[]") String[] tiposContato,
            @RequestParam(value = "email[]") String[] emails,
            @RequestParam(value = "tipoEmail[]") String[] tiposEmail, @RequestParam String rua,
            @RequestParam String numero, @RequestParam String bairro, @RequestParam String cep,
            @RequestParam String cidade, @RequestParam String estado,
            @RequestParam(required = false) String complemento, RedirectAttributes redirect) {

        try {
            Client client =
                    id != null ? clientService.buscarPorId(id).orElse(new Client()) : new Client();

            client.setNome(nome);
            client.setCpf(cpf);
            client.setDataNascimento(LocalDate.parse(dataNascimento));

            // Processar contatos
            client.setContatos(new ArrayList<>());
            for (int i = 0; i < contatos.length; i++) {
                if (!contatos[i].trim().isEmpty()) {
                    Contato contato = new Contato(contatos[i], tiposContato[i]);
                    client.addContato(contato);
                }
            }

            // Processar emails
            client.setEmails(new ArrayList<>());
            for (int i = 0; i < emails.length; i++) {
                if (!emails[i].trim().isEmpty()) {
                    Email email = new Email(emails[i], tiposEmail[i]);
                    client.addEmail(email);
                }
            }

            // Processar endereço
            Endereco endereco =
                    client.getEndereco() != null ? client.getEndereco() : new Endereco();
            endereco.setRua(rua);
            endereco.setNumero(numero);
            endereco.setBairro(bairro);
            endereco.setCep(cep);
            endereco.setCidade(cidade);
            endereco.setEstado(estado);
            endereco.setComplemento(complemento);
            client.setEndereco(endereco);

            clientService.salvar(client);
            redirect.addFlashAttribute("sucesso", "Cliente salvo com sucesso!");

        } catch (Exception e) {
            redirect.addFlashAttribute("erro", e.getMessage());
            return "redirect:/clientes/novo";
        }

        return "redirect:/clientes";
    }

    @GetMapping("/excluir/{id}")
    public String excluir(@PathVariable Long id, RedirectAttributes redirect) {
        try {
            clientService.excluir(id);
            redirect.addFlashAttribute("sucesso", "Cliente excluído com sucesso!");
        } catch (Exception e) {
            redirect.addFlashAttribute("erro", "Erro ao excluir cliente");
        }
        return "redirect:/clientes";
    }
}
