package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario    = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");

        // Validación simple (en producción usarías la BD)
        if ("admin".equals(usuario) && "1234".equals(contrasena)) {

            // ✅ Login exitoso: guardar usuario en sesión
            HttpSession sesion = request.getSession();
            sesion.setAttribute("usuarioLogueado", usuario);

            response.sendRedirect(request.getContextPath() + "/inicio");

        } else {
            // ❌ Credenciales incorrectas
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
        }
    }
}
