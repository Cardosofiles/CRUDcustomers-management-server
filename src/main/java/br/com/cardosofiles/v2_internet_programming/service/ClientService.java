package br.com.cardosofiles.v2_internet_programming.service;

import java.util.List;
import org.springframework.stereotype.Service;
import br.com.cardosofiles.v2_internet_programming.model.Client;
import br.com.cardosofiles.v2_internet_programming.repository.ClientRepository;

@Service
public class ClientService {

    private final ClientRepository repository;

    public ClientService(ClientRepository repository) {
        this.repository = repository;
    }

    public List<Client> listar() {
        return repository.findAll();
    }

    public Client buscarPorId(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Cliente não encontrado"));
    }

    public Client salvar(Client cliente) {
        validarCliente(cliente);
        return repository.save(cliente);
    }

    public void excluir(Long id) {
        if (!repository.existsById(id)) {
            throw new RuntimeException("Cliente não encontrado");
        }
        repository.deleteById(id);
    }

    private void validarCliente(Client cliente) {
        // Validar email duplicado
        if (cliente.getId() == null) {
            // Novo cliente
            if (repository.findByEmail(cliente.getEmail()).isPresent()) {
                throw new RuntimeException("Já existe um cliente cadastrado com este email");
            }
            if (repository.findByTelefone(cliente.getTelefone()).isPresent()) {
                throw new RuntimeException("Já existe um cliente cadastrado com este telefone");
            }
        } else {
            // Cliente existente (edição)
            if (repository.existsByEmailAndIdNot(cliente.getEmail(), cliente.getId())) {
                throw new RuntimeException("Já existe outro cliente cadastrado com este email");
            }
            if (repository.existsByTelefoneAndIdNot(cliente.getTelefone(), cliente.getId())) {
                throw new RuntimeException("Já existe outro cliente cadastrado com este telefone");
            }
        }
    }
}
