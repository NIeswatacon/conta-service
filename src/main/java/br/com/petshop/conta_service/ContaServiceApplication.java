package br.com.petshop.conta_service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
@EnableDiscoveryClient
public class ContaServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(ContaServiceApplication.class, args);
    }

    /**
     * Este bloco de código é para DIAGNÓSTICO.
     * Ele imprime o valor da variável de ambiente 'jwt.secret' assim que a aplicação inicia.
     * Isso nos ajudará a confirmar se a aplicação está lendo a variável corretamente.
     */
    @Bean
    public CommandLineRunner commandLineRunner(@Value("${jwt.secret:JWT_SECRET_NAO_ENCONTRADA}") String jwtSecret) {
        return args -> {
            System.out.println("====================================================================");
            System.out.println("VERIFICANDO VARIAVEL DE AMBIENTE 'jwt.secret'");
            System.out.println("Valor recebido: " + jwtSecret);
            System.out.println("====================================================================");
        };
    }
}