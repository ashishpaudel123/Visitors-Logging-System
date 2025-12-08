package com.visitor.system.model;
public class Visitor{
    private int id; private String name, phone, purpose, checkIn;
    public Visitor(int id,String name,String phone,String purpose,String checkIn){
        this.id=id; this.name=name; this.phone=phone; this.purpose=purpose; this.checkIn=checkIn;
    }
    public Visitor(String name,String phone,String purpose){
        this.name=name; this.phone=phone; this.purpose=purpose;
    }
    public int getId(){return id;}
    public String getName(){return name;}
    public String getPhone(){return phone;}
    public String getPurpose(){return purpose;}
    public String getCheckIn(){return checkIn;}
}