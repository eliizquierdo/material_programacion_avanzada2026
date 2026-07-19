package com.escuela;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/saludo")          // ← responde a la URL /saludo
public class HolaMundoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Obtener el dato que envió el formulario
        String nombre = req.getParameter("nombre");

        // 2. Guardarlo como atributo para que el JSP lo use
        req.setAttribute("nombre", nombre);

        // 3. Pasar el control al JSP que muestra el saludo
        req.getRequestDispatcher("/saludo.jsp")
           .forward(req, resp);
    }
}
