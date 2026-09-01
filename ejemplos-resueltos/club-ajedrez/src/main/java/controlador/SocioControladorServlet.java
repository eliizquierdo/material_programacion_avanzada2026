package controlador;

import modelo.dao.SocioDAO;
import modelo.vo.Socio;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/socio")
public class SocioControladorServlet extends HttpServlet {

    private final SocioDAO dao = new SocioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("agregar".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/vista/socio-form.jsp")
                   .forward(request, response);
        } else {
            listar(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("agregar".equals(action)) {
            agregar(request, response);
        } else if ("eliminar".equals(action)) {
            eliminar(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/socio");
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("socios", dao.getLista());
        request.getRequestDispatcher("/WEB-INF/vista/socio-lista.jsp")
               .forward(request, response);
    }

    private void agregar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String fechaStr = request.getParameter("fechaNacimiento");
        String categoria = request.getParameter("categoria");

        try {
            LocalDate fechaNacimiento = LocalDate.parse(fechaStr);
            Socio nuevo = new Socio(nombre, apellido, fechaNacimiento, categoria);

            if (nuevo.getEdad() < 6) {
                request.setAttribute("error", "El socio debe tener al menos 6 años.");
                request.setAttribute("nombre", nombre);
                request.setAttribute("apellido", apellido);
                request.setAttribute("fechaNacimiento", fechaStr);
                request.setAttribute("categoria", categoria);
                request.getRequestDispatcher("/WEB-INF/vista/socio-form.jsp")
                       .forward(request, response);
                return;
            }

            dao.agregar(nuevo);
            response.sendRedirect(request.getContextPath() + "/socio");

        } catch (DateTimeParseException e) {
            request.setAttribute("error", "Fecha inválida. Use el formato AAAA-MM-DD.");
            request.getRequestDispatcher("/WEB-INF/vista/socio-form.jsp")
                   .forward(request, response);
        }
    }

    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.eliminar(id);
        } catch (NumberFormatException e) {
            // id inválido, ignorar
        }
        response.sendRedirect(request.getContextPath() + "/socio");
    }
}
