package com.example.flutterappflutter2android;

import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.functions.Consumer;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "Flutter_love_android";
    public static final String BANNER_URL = "http://www.wanandroid.com/banner/json";
    private Data.Banner banner;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        if (methodCall.method.equals("showToast")) {
                            if (methodCall.hasArgument("msg")) {
                                String msg = methodCall.argument("msg");
                                showToast(msg);
                            } else if (methodCall.hasArgument("index")) {
                                //开始请求网络,获取banners
                                registRxBus((Integer) methodCall.argument("index"));
                                RetrofitHelper.get().getBanner();
                                if (banner != null) {
                                    result.success(banner.getImagePath());
                                }

                            } else {
                                showToast("Hello Flutter,I am in Android");
                            }

                        } else {
                            result.notImplemented();
                        }
                    }
                }
        );
    }

    private void registRxBus(final int index) {

        RxBus.get().toObservable(Data.class)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<Data>() {
                    @Override
                    public void accept(Data data) throws Exception {
                        List<Data.Banner> banners = data.getData();
                        if (banners != null && !banners.isEmpty()) {
                            banner = banners.get(index);
                            Log.e("GUAJU", "accept: " + banner.getImagePath());
                        }
                    }
                }, new Consumer<Throwable>() {
                    @Override
                    public void accept(Throwable throwable) throws Exception {
                        Toast.makeText(MainActivity.this, throwable.getMessage(), Toast.LENGTH_SHORT).show();
                    }
                });

    }


    public void showToast(String msg) {
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
    }

}
