package com.nz.napiinterface.controller;

import org.springframework.web.bind.annotation.*;


/**
 * @author Vizar
 */
@RestController()
public class HelloController {

    @GetMapping("/hello")
    public String sayHello() {
        return "GET: Hello";
    }

}
