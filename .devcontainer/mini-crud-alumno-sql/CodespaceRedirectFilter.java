package com.utu.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class CodespaceRedirectFilter implements Filter {
    private String codespaceBaseUrl;

    @Override
    public void init(FilterConfig config) {
        String name   = System.getenv("CODESPACE_NAME");
        String domain = System.getenv("GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN");
        if (name != null && domain != null) {
            codespaceBaseUrl = "https://" + name + "-8080." + domain;
        }
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        if (codespaceBaseUrl != null) {
            chain.doFilter(req, new FixedResponse((HttpServletResponse) res));
        } else {
            chain.doFilter(req, res);
        }
    }

    @Override public void destroy() {}

    private class FixedResponse extends HttpServletResponseWrapper {
        FixedResponse(HttpServletResponse r) { super(r); }

        @Override
        public void sendRedirect(String location) throws IOException {
            if (location.startsWith("http://localhost:8080")) {
                location = codespaceBaseUrl + location.substring("http://localhost:8080".length());
            } else if (location.startsWith("/")) {
                location = codespaceBaseUrl + location;
            }
            super.sendRedirect(location);
        }
    }
}
