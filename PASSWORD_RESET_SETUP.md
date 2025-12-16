# Password Reset Feature - Setup Guide

## 📋 Overview
A complete email-based password reset system has been implemented for your Visitor Entry System. This guide will help you set it up and test it.

---

## 🗄️ Step 1: Update Database Schema

Run the following SQL script to create the password reset tokens table:

```sql
-- Run this in your MySQL database
CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL,
    expiry_time DATETIME NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admins(id) ON DELETE CASCADE,
    INDEX idx_token (token),
    INDEX idx_admin_id (admin_id)
);
```

Or simply run:
```bash
mysql -u root -p visitor_entry_system < password_reset_schema.sql
```

---

## 📧 Step 2: Configure Email Settings

### Option A: Gmail (Recommended for Testing)

1. **Enable 2-Factor Authentication** on your Gmail account:
   - Go to https://myaccount.google.com/security
   - Enable 2-Step Verification

2. **Generate App Password**:
   - Visit https://myaccount.google.com/apppasswords
   - Select "Mail" and "Other (Custom name)"
   - Name it "Visitor Entry System"
   - Copy the 16-character password

3. **Update EmailUtil.java**:
   - Open: `src/main/java/com/visitor/system/utils/EmailUtil.java`
   - Update these lines (around line 20-22):
   ```java
   private static final String EMAIL = "your-email@gmail.com"; // Your Gmail
   private static final String PASSWORD = "xxxx xxxx xxxx xxxx"; // Your App Password
   ```

### Option B: Other SMTP Providers

**SendGrid:**
```java
private static final String SMTP_HOST = "smtp.sendgrid.net";
private static final String SMTP_PORT = "587";
private static final String EMAIL = "apikey";
private static final String PASSWORD = "your-sendgrid-api-key";
```

**Outlook/Office365:**
```java
private static final String SMTP_HOST = "smtp.office365.com";
private static final String SMTP_PORT = "587";
private static final String EMAIL = "your-email@outlook.com";
private static final String PASSWORD = "your-password";
```

**Yahoo Mail:**
```java
private static final String SMTP_HOST = "smtp.mail.yahoo.com";
private static final String SMTP_PORT = "587";
private static final String EMAIL = "your-email@yahoo.com";
private static final String PASSWORD = "your-app-password";
```

---

## 🏗️ Step 3: Build and Deploy

1. **Stop the current server** (if running):
   ```bash
   Press Ctrl+C in the terminal
   ```

2. **Clean and rebuild**:
   ```bash
   mvn clean package
   ```

3. **Deploy**:
   ```bash
   mvn cargo:run
   ```

---

## 🧪 Step 4: Test the Feature

### Test Flow:

1. **Go to Login Page**:
   ```
   http://localhost:8080/visitor-system/login
   ```

2. **Click "Forgot password?"** link

3. **Enter your email** (must be registered in the system)

4. **Check your email inbox** for reset link
   - Subject: "Password Reset Request - Visitor Entry System"
   - Link expires in 30 minutes

5. **Click the reset link** in email

6. **Enter new password** (minimum 6 characters)

7. **Login with new password**

### Test Email Configuration:

Create a simple test servlet or add this to any existing servlet temporarily:

```java
// Test email sending
boolean success = EmailUtil.sendTestEmail("your-email@gmail.com");
System.out.println("Email test result: " + success);
```

---

## 🔒 Security Features Implemented

✅ **Token Security**:
- Cryptographically random UUID tokens
- 30-minute expiry time
- One-time use (marked as used after reset)
- Tokens stored securely in database

✅ **Email Security**:
- No passwords sent in emails
- Reset link includes unique token
- TLS encryption for SMTP

✅ **Password Security**:
- Minimum 6 characters requirement
- Passwords hashed before storage
- Password confirmation required

✅ **Privacy**:
- Doesn't reveal if email exists (security best practice)
- Old tokens automatically deleted when requesting new one

---

## 📱 User Interface Features

### Forgot Password Page:
- Clean, user-friendly design
- Success/error message display
- Matches your existing design system
- Back to login link

### Reset Password Page:
- Password strength indicator (weak/medium/strong)
- Real-time password match validation
- Visual feedback for user input
- Secure token validation

### Login Page:
- Added "Forgot password?" link
- Success message after password reset
- Seamless integration with existing design

---

## 🐛 Troubleshooting

### Email Not Sending?

**Check console logs:**
```
Failed to send email: AuthenticationFailedException
```
→ Wrong email or password in EmailUtil.java

```
Failed to send email: MessagingException
```
→ Check SMTP settings (host/port)

**Gmail-specific issues:**
- Make sure 2FA is enabled
- Use App Password, not regular password
- Check "Less secure app access" is OFF (use App Password instead)

### Token Invalid/Expired?

- Tokens expire after 30 minutes
- Each token can only be used once
- Request a new reset link

### Database Errors?

```
Table 'password_reset_tokens' doesn't exist
```
→ Run the SQL schema script

```
Unknown column 'email' in 'field list'
```
→ Make sure admins table has email column

---

## 📊 Database Cleanup (Optional)

Add a scheduled task to clean up old tokens:

```sql
-- Delete expired or used tokens (run periodically)
DELETE FROM password_reset_tokens 
WHERE expiry_time < NOW() OR used = TRUE;
```

Or add this to your application startup:

```java
// In a ServletContextListener or startup class
String cleanupSql = "DELETE FROM password_reset_tokens WHERE expiry_time < NOW() OR used = TRUE";
// Execute periodically
```

---

## 🔧 Customization Options

### Change Token Expiry Time:
In `ForgotPasswordServlet.java` (line 33):
```java
private static final int TOKEN_EXPIRY_MINUTES = 30; // Change to 60 for 1 hour
```

### Customize Email Template:
Edit `buildEmailHTML()` method in `EmailUtil.java`

### Change Password Requirements:
Update validation in `ResetPasswordServlet.java` (line 68):
```java
if (newPassword.length() < 8) { // Change from 6 to 8
    req.setAttribute("error", "Password must be at least 8 characters long.");
    // ...
}
```

---

## ✅ Files Created/Modified

### New Files:
1. `password_reset_schema.sql` - Database schema
2. `src/main/java/com/visitor/system/utils/EmailUtil.java` - Email utility
3. `src/main/java/com/visitor/system/servlet/ForgotPasswordServlet.java` - Forgot password handler
4. `src/main/java/com/visitor/system/servlet/ResetPasswordServlet.java` - Reset password handler
5. `src/main/webapp/pages/forgot-password.jsp` - Forgot password page
6. `src/main/webapp/pages/reset-password.jsp` - Reset password page

### Modified Files:
1. `pom.xml` - Added Jakarta Mail dependencies
2. `src/main/webapp/pages/login.jsp` - Added forgot password link

---

## 📞 Support

If you encounter any issues:
1. Check server logs for error messages
2. Verify email configuration in EmailUtil.java
3. Ensure database schema is properly created
4. Test with a simple test email first

---

## 🎉 Next Steps

Once setup is complete and tested:
1. Update email credentials with production values
2. Consider adding rate limiting (prevent abuse)
3. Add email logging/monitoring
4. Set up automated token cleanup
5. Consider adding SMS option as alternative

---

**Setup Time**: ~15 minutes
**Difficulty**: Medium
**Prerequisites**: Gmail account with 2FA or other SMTP service
