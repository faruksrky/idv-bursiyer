package org.idv.bursiyer.service;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;

@Service
public class CurrentUserService {

    public EvaluatorIdentity currentEvaluator() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null
                || !authentication.isAuthenticated()
                || "anonymousUser".equals(authentication.getPrincipal())) {
            return new EvaluatorIdentity("dev-evaluator", "Geliştirme Kullanıcısı");
        }

        if (authentication.getPrincipal() instanceof Jwt jwt) {
            String sub = jwt.getSubject();
            String name = jwt.getClaimAsString("name");
            if (name == null || name.isBlank()) {
                name = jwt.getClaimAsString("preferred_username");
            }
            if (name == null || name.isBlank()) {
                name = sub;
            }
            return new EvaluatorIdentity(sub, name);
        }

        return new EvaluatorIdentity(authentication.getName(), authentication.getName());
    }

    public record EvaluatorIdentity(String sub, String name) {}
}
