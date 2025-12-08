package com.visitor.system.model;

public class Visitor {
    private int id;
    private String name;
    private String phone;
    private String purpose;
    private String checkIn;
    private int adminId;

    public Visitor(int id, String name, String phone, String purpose, String checkIn, int adminId) {
        this.id = id;
        this.name = name;
        this.phone = phone;
        this.purpose = purpose;
        this.checkIn = checkIn;
        this.adminId = adminId;
    }

    public Visitor(String name, String phone, String purpose, int adminId) {
        this.name = name;
        this.phone = phone;
        this.purpose = purpose;
        this.adminId = adminId;
    }

    // Getters
    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getPhone() {
        return phone;
    }

    public String getPurpose() {
        return purpose;
    }

    public String getCheckIn() {
        return checkIn;
    }

    public int getAdminId() {
        return adminId;
    }

    // Setters
    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public void setCheckIn(String checkIn) {
        this.checkIn = checkIn;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }
}
