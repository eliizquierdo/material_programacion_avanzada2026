package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/inicio")
public class InicioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false); // false = no crear si no existe

        if (sesion == null || sesion.getAttribute("usuarioLogueado") == null) {
            // No hay sesión activa → redirigir al login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Hay sesión activa → mostrar página
        String usuario = (String) sesion.getAttribute("usuarioLogueado");
        request.setAttribute("usuario", usuario);
        request.getRequestDispatcher("/WEB-INF/vistas/inicio.jsp").forward(request, response);
    }
}
