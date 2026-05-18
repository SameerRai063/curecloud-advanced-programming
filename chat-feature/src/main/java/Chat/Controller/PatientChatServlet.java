package Chat.Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/patient/chat")
public class PatientChatServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Minimal forwarding to the patient chat page. The JSP will fetch messages via AJAX if needed.
        request.getRequestDispatcher("/patient/PatientChat.jsp").forward(request, response);
    }
}

