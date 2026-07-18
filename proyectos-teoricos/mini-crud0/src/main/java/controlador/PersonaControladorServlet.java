package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import modelo.dao.PersonaDAO;
import modelo.vo.PersonaVO;

@WebServlet("/persona")
public class PersonaControladorServlet extends HttpServlet {
    private final PersonaDAO dao = new PersonaDAO();

    // ======================== GET ========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null)
            action = "";

        switch (action) {
            case "agregar": // mostrar formulario de alta (GET)
                request.getRequestDispatcher("/vista/persona-form.jsp")
                        .forward(request, response);
            break;

            case "listar": // listar explícito
                listar(request, response);
                break;

            default: // sin action o desconocida → listar
                listar(request, response);
                break;
        }
    }

    // ======================== POST ========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/persona");
            return;
        }

        switch (action) {
            case "agregar":
                agregar(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/persona");
        }
    }

    // ===================== Acciones privadas =====================
    private void agregar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int codigo = Integer.parseInt(request.getParameter("codigo"));
        String nombre = request.getParameter("nombre");
        dao.agregar(new PersonaVO(codigo, nombre));
        response.sendRedirect(request.getContextPath() + "/persona"); // PRG → listar
    }

    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("personas", dao.getLista());
        request.getRequestDispatcher("/vista/persona-lista.jsp")
                .forward(request, response);
    }
}
