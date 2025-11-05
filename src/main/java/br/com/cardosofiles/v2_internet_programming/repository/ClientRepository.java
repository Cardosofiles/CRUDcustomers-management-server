package br.com.cardosofiles.v2_internet_programming.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import br.com.cardosofiles.v2_internet_programming.model.Client;

@Repository
public interface ClientRepository extends JpaRepository<Client, Long> {

    // Busca por ID com endereço carregado
    @Query("SELECT c FROM Client c LEFT JOIN FETCH c.endereco WHERE c.id = :id")
    Optional<Client> findByIdWithEndereco(@Param("id") Long id);

    // Busca por CPF
    Optional<Client> findByCpf(String cpf);

    // Verifica CPF duplicado excluindo ID específico
    boolean existsByCpfAndIdNot(String cpf, Long id);
}
