package Chat.Model.dao;

import Chat.Model.ChatMessage;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import utils.DBConnection;

public class ChatDAO {

    private Connection con;

    public ChatDAO(Connection con) {
        this.con = con;
    }

    public ChatDAO() {
        try {
            this.con = DBConnection.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean saveMessage(ChatMessage msg) throws Exception {
        String sql = "INSERT INTO chat_messages (sender_id, receiver_id, sender_name, receiver_name, sender_role, message, sent_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, msg.getSenderId());
            ps.setInt(2, msg.getReceiverId());
            ps.setString(3, msg.getSenderName());
            ps.setString(4, msg.getReceiverName());
            ps.setString(5, msg.getSenderRole());
            ps.setString(6, msg.getMessage());

            int affected = ps.executeUpdate();
            if (affected == 0) return false;

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    msg.setId(keys.getInt(1));
                }
            }
            return true;
        }
    }

    public List<ChatMessage> getConversation(int a, int b) throws Exception {
        List<ChatMessage> out = new ArrayList<>();
        String sql = "SELECT id, sender_id, receiver_id, sender_name, receiver_name, sender_role, message, sent_at " +
                "FROM chat_messages " +
                "WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?) " +
                "ORDER BY sent_at ASC";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, a);
            ps.setInt(2, b);
            ps.setInt(3, b);
            ps.setInt(4, a);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatMessage m = new ChatMessage();
                    m.setId(rs.getInt("id"));
                    m.setSenderId(rs.getInt("sender_id"));
                    m.setReceiverId(rs.getInt("receiver_id"));
                    m.setSenderName(rs.getString("sender_name"));
                    m.setReceiverName(rs.getString("receiver_name"));
                    m.setSenderRole(rs.getString("sender_role"));
                    m.setMessage(rs.getString("message"));
                    m.setSentAt(rs.getTimestamp("sent_at"));
                    out.add(m);
                }
            }
        }
        return out;
    }
}

