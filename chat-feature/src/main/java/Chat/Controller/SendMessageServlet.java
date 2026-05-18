package Chat.Controller;

import Chat.Model.ChatMessage;
import Chat.Model.dao.ChatDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/sendMessage")
public class SendMessageServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String senderIdStr = request.getParameter("senderId");
        String receiverIdStr = request.getParameter("receiverId");
        String senderName = request.getParameter("senderName");
        String receiverName = request.getParameter("receiverName");
        String senderRole = request.getParameter("senderRole");
        String message = request.getParameter("message");

        try (PrintWriter out = response.getWriter()) {
            if (senderIdStr == null || receiverIdStr == null || message == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"success\":false,\"error\":\"missing_params\"}");
                return;
            }

            int senderId = Integer.parseInt(senderIdStr);
            int receiverId = Integer.parseInt(receiverIdStr);

            ChatMessage cm = new ChatMessage(senderId, receiverId, senderName, receiverName, senderRole, message);

            try {
                ChatDAO dao = new ChatDAO();
                boolean saved = dao.saveMessage(cm);
                if (saved) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    out.write("{\"success\":true,\"id\":" + cm.getId() + "}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    out.write("{\"success\":false}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.write("{\"success\":false,\"error\":\"server_error\"}");
            }
        }
    }
}

