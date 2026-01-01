package com.welab.lms.config;

import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class TomcatConfig {

    @Bean
    public WebServerFactoryCustomizer<TomcatServletWebServerFactory> servletContainerCustomizer() {
        return factory -> {
            factory.addContextCustomizers(context -> {
                org.apache.catalina.Wrapper defaultServlet = (org.apache.catalina.Wrapper) context.findChild("default");
                if (defaultServlet != null) {
                    defaultServlet.addInitParameter("listings", "true");
                }
            });
        };
    }
}