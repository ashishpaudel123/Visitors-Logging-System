package com.visitor.system.servlet;

import com.visitor.system.model.Admin;
import com.visitor.system.utils.DBConnection;
import com.visitor.system.utils.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * ForgotPasswordServlet - Handles password reset requests
 * 
 * Features:
 * - Validates user email/username
 * - Generates secure reset token
 * - Sends reset link via email
 * - Stores token with expiry time
 */
@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private static final int TOKEN_EXPIRY_MINUTES = 30;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.getRequestDispatcher("/pages/forgot-password.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String email = req.getParameter("email");

        // Validate input
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Please enter your email address.");
            req.getRequestDispatcher("/pages/forgot-password.jsp").forward(req, res);
            return;
        }

        email = email.trim().toLowerCase();

        // Check if admin exists with this email
        Admin admin = getAdminByEmail(email);
        
        if (admin == null) {
            // For security, don't reveal if email exists
            req.setAttribute("success", "If an account exists with this email, you will receive a password reset link shortly.");
            req.getRequestDispatcher("/pages/forgot-password.jsp").forward(req, res);
            return;
        }

        // Generate reset token
        String token = UUID.randomUUID().toString();
        LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(TOKEN_EXPIRY_MINUTES);

        // Save token to database
        boolean tokenSaved = saveResetToken(admin.getId(), token, expiryTime);

        if (!tokenSaved) {
            req.setAttribute("error", "Unable to process your request. Please try again later.");
            req.getRequestDispatcher("/pages/forgot-password.jsp").forward(req, res);
            return;
        }

        // Build reset link
        String resetLink = buildResetLink(req, token);

        // Send email
        boolean emailSent = EmailUtil.sendPasswordResetEmail(admin.getEmail(), resetLink, admin.getUsername());

        if (emailSent) {
            req.setAttribute("success", "Password reset link has been sent to your email. Please check your inbox.");
        } else {
            req.setAttribute("error", "Failed to send email. Please check your email configuration or try again later.");
        }

        req.getRequestDispatcher("/pages/forgot-password.jsp").forward(req, res);
    }

    /**
     * Retrieves admin details by email
     */
    private Admin getAdminByEmail(String email) {
        String sql = "SELECT id, username, email FROM admins WHERE email = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setEmail(rs.getString("email"));
                // Note: organization field exists in DB but not in Admin model
                return admin;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }

    /**
     * Saves the reset token to database
     */
    private boolean saveResetToken(int adminId, String token, LocalDateTime expiryTime) {
        // First, clean up old tokens for this admin
        String deleteSql = "DELETE FROM password_reset_tokens WHERE admin_id = ?";
        String insertSql = "INSERT INTO password_reset_tokens (admin_id, token, expiry_time) VALUES (?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection()) {
            // Delete old tokens
            try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                ps.setInt(1, adminId);
                ps.executeUpdate();
            }
            
            // Insert new token
            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                ps.setInt(1, adminId);
                ps.setString(2, token);
                ps.setString(3, expiryTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
                
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Builds the password reset link
     */
    private String buildResetLink(HttpServletRequest req, String token) {
        String scheme = req.getScheme();
        String serverName = req.getServerName();
        int serverPort = req.getServerPort();
        String contextPath = req.getContextPath();
        
        String baseUrl;
        if ((scheme.equals("http") && serverPort == 80) || (scheme.equals("https") && serverPort == 443)) {
            baseUrl = scheme + "://" + serverName + contextPath;
        } else {
            baseUrl = scheme + "://" + serverName + ":" + serverPort + contextPath;
        }
        
        return baseUrl + "/reset-password?token=" + token;
    }
}
