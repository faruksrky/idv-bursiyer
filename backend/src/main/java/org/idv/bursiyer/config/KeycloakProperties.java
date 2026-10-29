package org.idv.bursiyer.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.keycloak")
public record KeycloakProperties(
        String serverUrl,
        String realm,
        String clientId
) {}
