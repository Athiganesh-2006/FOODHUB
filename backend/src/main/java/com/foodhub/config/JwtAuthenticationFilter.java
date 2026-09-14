package com.foodhub.config;

import com.foodhub.entity.User;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;

/**
 * Validates the {@code Authorization: Bearer <jwt>} header on every request.
 *
 *  - valid token   -> authenticates the request in the SecurityContext AND
 *                     exposes a trusted {@code X-User-Id} header (the token's
 *                     subject) so the existing controllers/services keep working
 *                     unchanged, now reading the id from the JWT, not the client.
 *  - no token       -> request continues unauthenticated (protected URLs then 401)
 *  - invalid/expired-> context stays empty; any client-sent X-User-Id is stripped
 */
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    static final String USER_ID_HEADER = "X-User-Id";

    private final JwtService jwtService;

    public JwtAuthenticationFilter(JwtService jwtService) {
        this.jwtService = jwtService;
    }

    @Override
    protected void doFilterInternal(@NonNull HttpServletRequest request,
                                    @NonNull HttpServletResponse response,
                                    @NonNull FilterChain chain)
            throws ServletException, IOException {

        String trustedUserId = null;
        String auth = request.getHeader("Authorization");

        if (auth != null && auth.startsWith("Bearer ")) {
            String token = auth.substring(7).trim();
            try {
                Claims claims = jwtService.parse(token);
                Long userId = Long.valueOf(claims.getSubject());
                User.Role role = User.Role.valueOf(String.valueOf(claims.get("role")));
                String email = String.valueOf(claims.get("email"));

                UserPrincipal principal = new UserPrincipal(userId, email, role);
                UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(
                                principal, null, principal.getAuthorities());
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authentication);

                trustedUserId = String.valueOf(userId);
            } catch (JwtException | IllegalArgumentException ex) {
                // Bad signature / malformed / expired -> leave unauthenticated.
                SecurityContextHolder.clearContext();
            }
        }

        // Controllers read @RequestHeader("X-User-Id"); only ever let them see
        // the JWT-derived value (never a value the client sent themselves).
        chain.doFilter(new TrustedUserIdRequest(request, trustedUserId), response);
    }

    /** Replaces the {@code X-User-Id} header with the JWT subject (or removes it). */
    private static final class TrustedUserIdRequest extends HttpServletRequestWrapper {
        private final String userId; // nullable

        TrustedUserIdRequest(HttpServletRequest request, String userId) {
            super(request);
            this.userId = userId;
        }

        @Override
        public String getHeader(String name) {
            if (USER_ID_HEADER.equalsIgnoreCase(name)) {
                return userId;
            }
            return super.getHeader(name);
        }

        @Override
        public Enumeration<String> getHeaders(String name) {
            if (USER_ID_HEADER.equalsIgnoreCase(name)) {
                return userId == null ? Collections.emptyEnumeration()
                        : Collections.enumeration(List.of(userId));
            }
            return super.getHeaders(name);
        }

        @Override
        public Enumeration<String> getHeaderNames() {
            List<String> names = new ArrayList<>();
            Enumeration<String> original = super.getHeaderNames();
            while (original.hasMoreElements()) {
                String n = original.nextElement();
                if (!USER_ID_HEADER.equalsIgnoreCase(n)) {
                    names.add(n);
                }
            }
            if (userId != null) {
                names.add(USER_ID_HEADER);
            }
            return Collections.enumeration(names);
        }
    }
}
