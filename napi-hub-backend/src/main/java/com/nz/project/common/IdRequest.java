package com.nz.project.common;

import lombok.Data;

import java.io.Serializable;

/**
 * 发布/下线请求
 */
@Data
public class IdRequest implements Serializable {

    /**
     * id
     */
    private Long id;

    private static final long serialVersionUID = 1L;
}