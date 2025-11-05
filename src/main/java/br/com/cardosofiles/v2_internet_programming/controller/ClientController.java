package br.com.cardosofiles.v2_internet_programming.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import br.com.cardosofiles.v2_internet_programming.model.Client;
import br.com.cardosofiles.v2_internet_programming.service.ClientService;

@Controller
@RequestMapping("/clientes")
public class ClientController {
    private final ClientService service;

    public ClientController(ClientService service) {
        this.service = service;
    }

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("clientes", service.listar());
        return "listar";
    }

    @GetMapping("/novo")
    public String novo(Model model) {
        model.addAttribute("cliente", new Client());
        return "form";
    }

    @PostMapping("/salvar")
    public String salvar(Client cliente, RedirectAttributes redirectAttributes, Model model) {
        try {
            // Validações básicas
            if (cliente.getNome() == null || cliente.getNome().trim().isEmpty()) {
                throw new RuntimeException("O nome é obrigatório");
            }
            if (cliente.getEmail() == null || cliente.getEmail().trim().isEmpty()) {
                throw new RuntimeException("O email é obrigatório");
            }
            if (cliente.getTelefone() == null || cliente.getTelefone().trim().isEmpty()) {
                throw new RuntimeException("O telefone é obrigatório");
            }

            // Validar formato de email
            if (!cliente.getEmail().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
                throw new RuntimeException("Email inválido");
            }

            service.salvar(cliente);
            redirectAttributes.addFlashAttribute("sucesso",
                    cliente.getId() == null ? "Cliente cadastrado com sucesso!"
                            : "Cliente atualizado com sucesso!");
            return "redirect:/clientes";
        } catch (Exception e) {
            model.addAttribute("erro", e.getMessage());
            model.addAttribute("cliente", cliente);
            return "form";
        }
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model,
            RedirectAttributes redirectAttributes) {
        try {
            model.addAttribute("cliente", service.buscarPorId(id));
            return "form";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erro", e.getMessage());
            return "redirect:/clientes";
        }
    }

    @GetMapping("/excluir/{id}")
    public String excluir(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            service.excluir(id);
            redirectAttributes.addFlashAttribute("sucesso", "Cliente excluído com sucesso!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erro", e.getMessage());
        }
        return "redirect:/clientes";
    }
}
