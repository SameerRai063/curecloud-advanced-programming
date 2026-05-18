# Chat Feature

This folder contains a self-contained chat feature that can be reviewed or packaged independently.

Structure:

- chat_table.sql — optional DDL for the chat_messages table (run manually)
- src/main/java/Chat/Model — ChatMessage model
- src/main/java/Chat/Model/dao — ChatDAO (JDBC operations)
- src/main/java/Chat/Controller — Servlets
- src/main/webapp/patient — PatientChat.jsp
- src/main/webapp/receptionists — ReceptionistChat.jsp

Notes:
- The main application already contains a working copy under `src/main/java/Chat` and `src/main/webapp`.
- This folder is provided as a standalone package for distribution or review.

