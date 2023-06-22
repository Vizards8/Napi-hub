package com.nz.napiclientsdk;

import com.nz.napiclientsdk.client.NApiClient;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 * NApi 客户端配置
 */
@Configuration
@ConfigurationProperties("napi.client")
@Data
@ComponentScan
public class NApiClientConfig {

    private String accessKey;

    private String secretKey;

    @Bean
    public NApiClient nApiClient() {
        return new NApiClient(accessKey, secretKey);
    }

}