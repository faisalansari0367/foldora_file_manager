package com.example.files;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.ContentResolver;
import android.content.IntentFilter;
import android.content.Intent;

// import android.os.BatteryManager;
import android.os.Environment;
import android.os.StatFs;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;

import android.net.Uri;

import java.io.File;
import java.io.FilePermission;

import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;

import java.nio.file.Path;
import java.nio.file.Paths;

import java.security.AccessController;
// import javax.print.attribute.standard.DocumentName;

import java.io.IOException;
import java.lang.Exception;

import android.Manifest.permission;
import androidx.core.app.ActivityCompat;

// import android.support.v4.provider.DocumentFile;
// import androidx.documentfile.provider.DocumentFile;


import android.graphics.Bitmap;
import io.flutter.plugins.GeneratedPluginRegistrant;
import java.io.ByteArrayOutputStream;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.lang.Object;
import android.graphics.drawable.BitmapDrawable;

// Package Manager
import android.content.pm.PackageManager;
import android.content.pm.PackageInfo;
import android.graphics.drawable.Drawable;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.example.files";

  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler((call, result) -> {
          // Note: this method is invoked on the main thread.
          switch (call.method) {
            case "getApplicationIcon":
              String APKFilePath = call.argument("APKFilePath");
              result.success(getApplicationIcon(APKFilePath));
              break;
            case "getSpace":
              result.success(getSpace());
            case "deleteWhenError":
              List<String> paths = call.argument("paths");
              result.success(deleteFileSystemEntity(paths));
            default:
              result.notImplemented();
              break;
          }
        });
  }

  public byte[] getApplicationIcon(String path) {
    PackageManager pm = getPackageManager();
    PackageInfo pi = pm.getPackageArchiveInfo(path, 0);

    pi.applicationInfo.sourceDir = path;
    pi.applicationInfo.publicSourceDir = path;

    String packageName = pi.packageName;
    System.out.println(packageName);

    Drawable icon = pi.applicationInfo.loadIcon(pm);
    Bitmap bitmap = ((BitmapDrawable) icon).getBitmap();
    ByteArrayOutputStream stream = new ByteArrayOutputStream();
    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
    byte[] image = stream.toByteArray();
    bitmap.recycle();
    return image;
  }

  ArrayList<HashMap> getSpace() {
    String path = Environment.getExternalStorageDirectory().getPath();
    final ArrayList<HashMap> extRootPaths = new ArrayList<>();
    final ArrayList<HashMap> sdCard = new ArrayList<>();
    final File[] appsDir = getExternalFilesDirs(null);
    for (final File file : appsDir) {
      String a = file.getAbsolutePath();
      if (Environment.isExternalStorageRemovable(file)) {
        String value = Environment.getExternalStorageState(file);
        if (!value.equals(Environment.MEDIA_UNMOUNTED)) {
          sdCard.add(getSpaceDetails(a));
        }
      } else {
        extRootPaths.add(getSpaceDetails(a));
      }
    }
    if (sdCard.isEmpty()) {
      return extRootPaths;
    } else {
      extRootPaths.addAll(sdCard);
      return extRootPaths;
    }
  }

  HashMap<String, String> getSpaceDetails(String path) {
    StatFs stat = new StatFs(path);
    long blockSize = stat.getBlockSizeLong();
    long totalBlocks = stat.getBlockCountLong();
    long availableBlocks = stat.getAvailableBlocksLong();
    long availableBytes = blockSize * availableBlocks;
    long totalBytes = totalBlocks * blockSize;

    HashMap<String, String> map = new HashMap<String, String>();
    map.put("total", totalBytes + "");
    map.put("free", availableBytes + "");
    map.put("path", path);
    return map;
  }

  boolean deleteFileSystemEntity(List<String> list) {
    try {
      for (String path : list) {
        Path filePath = Paths.get(path);
        File file = filePath.toFile();
        System.out.println(file);
        deleteDirectory(file);
        if (file.canWrite() == false) {
          Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
          Uri uri = Uri.fromFile(file);
          startActivity(intent);
          // getContentResolver().takePersistableUriPermission(uri,
          //     // Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION,
          //     Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_GRANT_READ_URI_PERMISSION);
          deleteDirectory(file);
        }
      }
      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }

  }

  public void deleteDirectory(File file) {
    if (file.exists()) {
      if (file.isDirectory()) {
        File[] files = file.listFiles();
        for (int i = 0; i < files.length; i++) {
          if (files[i].isDirectory()) {
            deleteDirectory(files[i]);
          } else {
            files[i].delete();
          }
        }
      }
      file.delete();
    }
  }

}