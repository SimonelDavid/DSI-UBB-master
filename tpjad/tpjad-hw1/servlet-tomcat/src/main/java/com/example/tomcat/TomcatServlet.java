package com.example.tomcat;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class TomcatServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String wildflyUrl = "http://wildfly-service.tpjad-hw1.svc.cluster.local:8081/servlet-wildfly-1.0-SNAPSHOT/wildfly";

        String wildflyResponse = HttpRequestHelper.sendGet(wildflyUrl);

        resp.setContentType("text/plain");
        PrintWriter writer = resp.getWriter();
        writer.println("And Tomcat received a message from WildFly: \n" + wildflyResponse);
        writer.flush();
    }
}