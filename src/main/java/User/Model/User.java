package User.Model;

import java.sql.Date;
import java.sql.Timestamp;

public class User {

    private int id;
    private String name;
    private String gender;
    private Date dob;
    private String address;
    private String phone;
    private String email;
    private String password;
    private String profileImage;
    private String role;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructor (Empty)
    public User() {}

    // Constructor (Without ID)
    public User(String name, String gender, Date dob, String address,
                String phone, String email, String password,
                String profileImage, String role) {

        this.name = name;
        this.gender = gender;
        this.dob = dob;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.password = password;
        this.profileImage = profileImage;
        this.role = role;
    }

    // Getters and Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}