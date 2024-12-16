package com.example.jetty;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class JettyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String tomcatResponse = HttpRequestHelper.sendGet("http://tomcat-service.tpjad-hw1.svc.cluster.local:8080/servlet-tomcat/tomcat");

        resp.setContentType("text/plain");
        resp.getWriter().write("Jetty received a message from Tomcat: \n" + tomcatResponse);
    }
}