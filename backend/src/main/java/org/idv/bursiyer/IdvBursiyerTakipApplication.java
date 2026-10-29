package org.idv.bursiyer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class IdvBursiyerTakipApplication {

	public static void main(String[] args) {
		SpringApplication.run(IdvBursiyerTakipApplication.class, args);
	}

}
