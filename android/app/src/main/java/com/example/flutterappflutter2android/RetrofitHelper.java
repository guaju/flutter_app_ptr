package com.example.flutterappflutter2android;


import java.util.concurrent.TimeUnit;

import io.reactivex.Observable;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;
import retrofit2.converter.gson.GsonConverterFactory;

public class RetrofitHelper {

    private static RetrofitHelper retrofitHelper;
    private final Retrofit retrofit;
    private final BannerService bannerService;

    private RetrofitHelper() {
        OkHttpClient okhttp = new OkHttpClient.Builder()
                .connectTimeout(1, TimeUnit.SECONDS)
                .readTimeout(1, TimeUnit.SECONDS).build();
        retrofit = new Retrofit.Builder()
                .baseUrl("http://www.wanandroid.com/banner/")
                .client(okhttp)
                .addConverterFactory(GsonConverterFactory.create())
                .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                .build();
        bannerService = retrofit.create(BannerService.class);
    }

    public static RetrofitHelper get() {
        return Holder.HELPER;
    }

    public void getBanner() {
        Observable<Data> banners = bannerService.getBanners();
        banners.observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.io())
                .subscribe(new Consumer<Data>() {
                    @Override
                    public void accept(Data data) throws Exception {
                        if (data != null) {
                            RxBus.get().post(data);
                        }
                    }
                });
    }

    private static class Holder {
        private static final RetrofitHelper HELPER = new RetrofitHelper();
    }
}
