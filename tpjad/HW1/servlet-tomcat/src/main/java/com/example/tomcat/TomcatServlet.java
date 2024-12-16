package com.example.tomcat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/tomcat")
public class TomcatServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String responseMessage = "Message from TomcatServlet";
        String wildflyResponse = HttpRequestHelper.sendGet("http://wildfly:8080/wildfly");
        resp.setContentType("text/plain");
        PrintWriter writer = resp.getWriter();
        writer.println("Tomcat received: " + wildflyResponse);
        writer.flush();
    }
}