package Chat.Controller;

import Chat.Model.ChatMessage;
import Chat.Model.dao.ChatDAO;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.JsonReader;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import java.io.StringReader;
import java.util.Collections;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Simple WebSocket endpoint for real-time chat.
 * Connect using: ws://host:port/context/ws/chat?userId=123
 */
@ServerEndpoint("/ws/chat")
public class ChatWebSocket {

    // Map userId -> set of WebSocket sessions (supports multiple devices/tabs)
    private static final Map<Integer, Set<Session>> userSessions = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session) {
        try {
            String uid = null;
            if (session.getRequestParameterMap().containsKey("userId")) {
                uid = session.getRequestParameterMap().get("userId").get(0);
            } else if (session.getQueryString() != null) {
                // fallback parse
                String qs = session.getQueryString();
                for (String part : qs.split("&")) {
                    if (part.startsWith("userId=")) { uid = part.substring(part.indexOf('=')+1); break; }
                }
            }

            if (uid != null) {
                int userId = Integer.parseInt(uid);
                userSessions.computeIfAbsent(userId, k -> Collections.newSetFromMap(new ConcurrentHashMap<>())).add(session);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        // Expecting JSON: {senderId, receiverId, senderName, receiverName, senderRole, message}
        try (JsonReader jr = Json.createReader(new StringReader(message))) {
            JsonObject obj = jr.readObject();

            ChatMessage msg = new ChatMessage();
            msg.setSenderId(obj.getInt("senderId"));
            msg.setReceiverId(obj.getInt("receiverId"));
            msg.setSenderName(obj.getString("senderName", ""));
            msg.setReceiverName(obj.getString("receiverName", ""));
            msg.setSenderRole(obj.getString("senderRole", ""));
            msg.setMessage(obj.getString("message", ""));

            // Persist
            ChatDAO dao = new ChatDAO();
            dao.saveMessage(msg);

            // Build outgoing JSON
            JsonObjectBuilder out = Json.createObjectBuilder()
                    .add("id", msg.getId())
                    .add("senderId", msg.getSenderId())
                    .add("receiverId", msg.getReceiverId())
                    .add("senderName", msg.getSenderName())
                    .add("receiverName", msg.getReceiverName())
                    .add("senderRole", msg.getSenderRole())
                    .add("message", msg.getMessage());

            String outStr = out.build().toString();

            // Send to receiver
            sendToUser(msg.getReceiverId(), outStr);
            // Also send back to sender (to confirm delivery)
            sendToUser(msg.getSenderId(), outStr);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session) {
        // Remove session from all user sets
        for (Map.Entry<Integer, Set<Session>> e : userSessions.entrySet()) {
            Set<Session> set = e.getValue();
            if (set.remove(session)) {
                if (set.isEmpty()) userSessions.remove(e.getKey());
                break;
            }
        }
    }

    private void sendToUser(int userId, String message) {
        Set<Session> sessions = userSessions.get(userId);
        if (sessions == null) return;
        for (Session s : new HashSet<>(sessions)) {
            try {
                if (s.isOpen()) s.getAsyncRemote().sendText(message);
            } catch (Exception ignored) {}
        }
    }
}

