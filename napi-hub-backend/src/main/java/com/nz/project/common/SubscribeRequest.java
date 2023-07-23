package com.nz.project.common;

import lombok.Data;

import java.io.Serializable;

/**
 * 订阅接口请求
 */
@Data
public class SubscribeRequest implements Serializable {

    /**
     * id
     */
    private Long interfaceId;

    private Long userId;

    private static final long serialVersionUID = 1L;
}