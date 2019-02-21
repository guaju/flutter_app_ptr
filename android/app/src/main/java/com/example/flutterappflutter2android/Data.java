package com.example.flutterappflutter2android;

import java.util.List;

public class Data {

    private int errorCode;
    private String errorMsg;
    private List<Banner> data;


    public List<Banner> getData() {
        return data;
    }

    public void setData(List<Banner> data) {
        this.data = data;
    }

    public static class Banner {


        private String desc;
        private int id;
        private String imagePath;
        private int isVisible;
        private int order;
        private String title;
        private int type;
        private String url;


        public String getImagePath() {
            return imagePath;
        }


    }
}
