package br.com.cardosofiles.v2_internet_programming.service;

import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import br.com.cardosofiles.v2_internet_programming.model.Client;
import br.com.cardosofiles.v2_internet_programming.repository.ClientRepository;

@Service
public class ClientService {

    @Autowired
    private ClientRepository clientRepository;

    public List<Client> listarTodos() {
        return clientRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Optional<Client> buscarPorId(Long id) {
        // Carregar em 3 queries separadas para evitar MultipleBagFetchException
        Optional<Client> clientOpt = clientRepository.findByIdWithEndereco(id);

        if (clientOpt.isPresent()) {
            // Força o carregamento de contatos
            clientRepository.findByIdWithContatos(id);
            // Força o carregamento de emails
            clientRepository.findByIdWithEmails(id);
        }

        return clientOpt;
    }

    @Transactional
    public Client salvar(Client client) {
        validarCpfUnico(client);
        validarContatosMinimos(client);
        validarEmailsMinimos(client);
        return clientRepository.save(client);
    }

    @Transactional
    public void excluir(Long id) {
        clientRepository.deleteById(id);
    }

    private void validarCpfUnico(Client client) {
        if (client.getId() == null) {
            if (clientRepository.findByCpf(client.getCpf()).isPresent()) {
                throw new IllegalArgumentException("CPF já cadastrado");
            }
        } else {
            if (clientRepository.existsByCpfAndIdNot(client.getCpf(), client.getId())) {
                throw new IllegalArgumentException("CPF já cadastrado para outro cliente");
            }
        }
    }

    private void validarContatosMinimos(Client client) {
        if (client.getContatos() == null || client.getContatos().isEmpty()) {
            throw new IllegalArgumentException("Pelo menos um contato é obrigatório");
        }
    }

    private void validarEmailsMinimos(Client client) {
        if (client.getEmails() == null || client.getEmails().isEmpty()) {
            throw new IllegalArgumentException("Pelo menos um email é obrigatório");
        }
    }
}
