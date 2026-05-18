package Chat.Model;

import java.sql.Timestamp;

/**
 * MODEL CLASS — ChatMessage.java
 *
 * This class represents one chat message.
 * It maps to one row in the 'chat_messages' table in the database.
 *
 * In MVC pattern:
 *   Model = this class (data)
 *   View  = JSP pages
 *   Controller = Servlets
 */
public class ChatMessage {

    // ── Fields (match column names in the database table) ──────────────
    private int id;
    private int senderId;
    private int receiverId;
    private String senderName;
    private String receiverName;
    private String senderRole;    // either "patient" or "receptionist"
    private String message;
    private Timestamp sentAt;

    // ── Default constructor (required) ─────────────────────────────────
    public ChatMessage() {}

    // ── Constructor with all fields ────────────────────────────────────
    public ChatMessage(int senderId, int receiverId, String senderName,
                       String receiverName, String senderRole, String message) {
        this.senderId     = senderId;
        this.receiverId   = receiverId;
        this.senderName   = senderName;
        this.receiverName = receiverName;
        this.senderRole   = senderRole;
        this.message      = message;
    }

    // ── Getters & Setters ──────────────────────────────────────────────

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }

    public int getReceiverId() { return receiverId; }
    public void setReceiverId(int receiverId) { this.receiverId = receiverId; }

    public String getSenderName() { return senderName; }
    public void setSenderName(String senderName) { this.senderName = senderName; }

    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }

    public String getSenderRole() { return senderRole; }
    public void setSenderRole(String senderRole) { this.senderRole = senderRole; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getSentAt() { return sentAt; }
    public void setSentAt(Timestamp sentAt) { this.sentAt = sentAt; }
}
