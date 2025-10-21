package com.inventory.models;

public class User {

    // PROPERTIES
    private int userId;
    private String userName, password, medicalStoreName, medicalStoreLogo;

    // CONSTRUCTOR
    public User() {
    }

    public User(int userId, String userName, String password, String medicalStoreName, String medicalStoreLogo) {
        this.userId = userId;
        this.userName = userName;
        this.password = password;
        this.medicalStoreName = medicalStoreName;
        this.medicalStoreLogo = medicalStoreLogo;
    }

    // GETTERS AND SETTERS
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getMedicalStoreName() {
        return medicalStoreName;
    }

    public void setMedicalStoreName(String medicalStoreName) {
        this.medicalStoreName = medicalStoreName;
    }

    public String getMedicalStoreLogo() {
        return medicalStoreLogo;
    }

    public void setMedicalStoreLogo(String medicalStoreLogo) {
        this.medicalStoreLogo = medicalStoreLogo;
    }
}
