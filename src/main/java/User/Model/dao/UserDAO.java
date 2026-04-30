package User.Model.dao;

import User.Model.User;

import java.sql.*;

public class UserDAO implements UserInterface {

    private Connection con;

    public UserDAO(Connection con) {
        this.con = con;
    }

    @Override
    public int addUser(User user) throws Exception {

        String sql = "INSERT INTO users(name, gender, email, password, role) VALUES (?, ?, ?, ?, ?)";

        PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

        ps.setString(1, user.getName());
        ps.setString(2, user.getGender());
        ps.setString(3, user.getEmail());
        ps.setString(4, user.getPassword());
        ps.setString(5, user.getRole());

        ps.executeUpdate();

        ResultSet rs = ps.getGeneratedKeys();

        if (rs.next()) {
            return rs.getInt(1);
        }

        return 0;
    }

    @Override
    public User getUserByEmail(String email) throws Exception {

        String sql = "SELECT * FROM users WHERE email=?";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, email);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            User u = new User();
            u.setId(rs.getInt("id"));
            u.setName(rs.getString("name"));
            u.setGender(rs.getString("gender"));
            u.setEmail(rs.getString("email"));
            u.setPassword(rs.getString("password"));
            u.setRole(rs.getString("role"));
            return u;
        }

        return null;
    }
}