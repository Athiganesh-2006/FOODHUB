package com.foodhub.dto;

import com.foodhub.entity.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * { "token": "<jwt>", "user": { id, name, email, phone, address, role } }
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {

    private String token;
    private UserInfo user;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UserInfo {
        private Long id;
        private String name;
        private String email;
        private String phone;
        private String address;
        private User.Role role;

        public static UserInfo from(User u) {
            return new UserInfo(u.getId(), u.getName(), u.getEmail(),
                    u.getPhone(), u.getAddress(), u.getRole());
        }
    }

    public static LoginResponse of(String token, User user) {
        return new LoginResponse(token, UserInfo.from(user));
    }
}
