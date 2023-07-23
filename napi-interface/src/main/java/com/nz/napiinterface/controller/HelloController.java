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

    @GetMapping("/hello1")
    public String sayHello1() {
        return "GET: Hello1";
    }

    @GetMapping("/hello2")
    public String sayHello2() {
        return "GET: Hello2";
    }

    @GetMapping("/hello3")
    public String sayHello3() {
        return "GET: Hello3";
    }

    @GetMapping("/hello4")
    public String sayHello4() {
        return "GET: Hello4";
    }

    @GetMapping("/hello5")
    public String sayHello5() {
        return "GET: Hello5";
    }

}
