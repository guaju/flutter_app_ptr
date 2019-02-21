package com.example.flutterappflutter2android;


import io.reactivex.Observable;
import retrofit2.http.GET;

public interface BannerService {
    @GET("json")
    Observable<Data> getBanners();
}
