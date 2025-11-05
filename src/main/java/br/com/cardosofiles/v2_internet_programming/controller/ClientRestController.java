package br.com.cardosofiles.v2_internet_programming.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import br.com.cardosofiles.v2_internet_programming.model.Client;
import br.com.cardosofiles.v2_internet_programming.service.ClientService;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/clientes")
public class ClientRestController {

    @Autowired
    private ClientService clientService;

    @GetMapping
    public ResponseEntity<Map<String, Object>> listarTodos() {
        List<Client> clients = clientService.listarTodos();

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", clients);
        response.put("total", clients.size());
        response.put("message", "Clientes recuperados com sucesso");

        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> buscarPorId(@PathVariable Long id) {
        return clientService.buscarPorId(id).map(client -> {
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", client);
            response.put("message", "Cliente encontrado");
            return ResponseEntity.ok(response);
        }).orElseGet(() -> {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Cliente não encontrado");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        });
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> criar(@Valid @RequestBody Client client) {
        try {
            Client savedClient = clientService.salvar(client);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", savedClient);
            response.put("message", "Cliente criado com sucesso");

            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (IllegalArgumentException e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> atualizar(@PathVariable Long id,
            @Valid @RequestBody Client client) {
        return clientService.buscarPorId(id).map(existingClient -> {
            client.setId(id);
            try {
                Client updatedClient = clientService.salvar(client);

                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("data", updatedClient);
                response.put("message", "Cliente atualizado com sucesso");

                return ResponseEntity.ok(response);
            } catch (IllegalArgumentException e) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", e.getMessage());
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
        }).orElseGet(() -> {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Cliente não encontrado");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        });
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> excluir(@PathVariable Long id) {
        return clientService.buscarPorId(id).map(client -> {
            clientService.excluir(id);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Cliente excluído com sucesso");

            return ResponseEntity.ok(response);
        }).orElseGet(() -> {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Cliente não encontrado");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        });
    }
}
