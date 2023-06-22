package com.nz.napiinterface;

import com.nz.napiclientsdk.client.NApiClient;
import com.nz.napiclientsdk.model.User;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import javax.annotation.Resource;

@SpringBootTest
class NapiInterfaceApplicationTests {

    @Resource
    private NApiClient nApiClient;

    @Test
    void contextLoads() {
        String res = nApiClient.getNameByGet("nz");
        User user = new User();
        user.setUsername("nz");
        String usernameByPost = nApiClient.getUsernameByPost(user);
        System.out.println(res);
        System.out.println(usernameByPost);
    }

}
