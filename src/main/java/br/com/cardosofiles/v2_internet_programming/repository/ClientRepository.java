package br.com.cardosofiles.v2_internet_programming.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import br.com.cardosofiles.v2_internet_programming.model.Client;

@Repository
public interface ClientRepository extends JpaRepository<Client, Long> {

    Optional<Client> findByCpf(String cpf);

    boolean existsByCpfAndIdNot(String cpf, Long id);

    @Query("SELECT DISTINCT c FROM Client c LEFT JOIN FETCH c.endereco WHERE c.id = :id")
    Optional<Client> findByIdWithEndereco(@Param("id") Long id);

    @Query("SELECT DISTINCT c FROM Client c LEFT JOIN FETCH c.contatos WHERE c.id = :id")
    Optional<Client> findByIdWithContatos(@Param("id") Long id);

    @Query("SELECT DISTINCT c FROM Client c LEFT JOIN FETCH c.emails WHERE c.id = :id")
    Optional<Client> findByIdWithEmails(@Param("id") Long id);
}
