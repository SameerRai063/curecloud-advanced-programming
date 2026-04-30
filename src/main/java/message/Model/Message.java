package message.Model;

import java.sql.Timestamp;

public class Message {

    private int id;
    private int conversationId;
    private String senderType; // patient / receptionist
    private int senderId;
    private String message;
    private Timestamp createdAt;
    private boolean isRead;

    // Constructors
    public Message() {}

    public Message(int conversationId, String senderType, int senderId, String message) {
        this.conversationId = conversationId;
        this.senderType = senderType;
        this.senderId = senderId;
        this.message = message;
    }

    // Getters & Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getConversationId() { return conversationId; }
    public void setConversationId(int conversationId) { this.conversationId = conversationId; }

    public String getSenderType() { return senderType; }
    public void setSenderType(String senderType) { this.senderType = senderType; }

    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }
}