package com.nz.napiinterface.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LuckyController {

    @GetMapping("/lucky")
    public String getLuckyPrediction() {
        String prediction = "You will have a day filled with joy and success!";
        return prediction;
    }
}
