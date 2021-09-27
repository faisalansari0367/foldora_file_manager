package com.faisal.foldora;

import static android.os.Build.VERSION.SDK_INT;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.Settings;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.faisal.foldora";
  public static final int PERMISSION_REQUEST_CODE = 2296;
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler((call, result) -> {
          // Note: this method is invoked on the main thread.
          switch (call.method) {
            case "deleteWhenError":
              List<String> paths = call.argument("paths");
              final boolean value = deleteFileSystemEntity(paths);
              result.success(value);
              return;
            case "manageAllFilesPermission":
              requestPermission();
              return;
            default:
              result.notImplemented();
              break;
          }
        });
  }

  private void requestPermission() {
    if (SDK_INT >= Build.VERSION_CODES.R) {
      try {
        Intent intent = new Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION);
        intent.addCategory("android.intent.category.DEFAULT");
        intent.setData(Uri.parse(String.format("package:%s",getApplicationContext().getPackageName())));
        startActivityForResult(intent, 2296);
      } catch (Exception e) {
        Intent intent = new Intent();
        intent.setAction(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION);
        startActivityForResult(intent, 2296);
      }
    } else {
      //below android 11
      ActivityCompat.requestPermissions(this, new String[]{"WRITE_EXTERNAL_STORAGE"}, PERMISSION_REQUEST_CODE);
    }
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (requestCode == 2296) {
      if (SDK_INT >= Build.VERSION_CODES.Q) {
        if (Environment.isExternalStorageManager()) {
          // perform action when allow permission success
        } else {
          Toast.makeText(this, "Allow permission for storage access!", Toast.LENGTH_SHORT).show();
        }
      }
    }
  }

  @Override
  public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    switch (requestCode) {
      case PERMISSION_REQUEST_CODE:
        if (grantResults.length > 0) {
          boolean READ_EXTERNAL_STORAGE = grantResults[0] == PackageManager.PERMISSION_GRANTED;
          boolean WRITE_EXTERNAL_STORAGE = grantResults[1] == PackageManager.PERMISSION_GRANTED;
          System.out.println("Read external storage permission: " + READ_EXTERNAL_STORAGE);
          System.out.println("Write external storage permission: " + WRITE_EXTERNAL_STORAGE);

          if (READ_EXTERNAL_STORAGE && WRITE_EXTERNAL_STORAGE) {
            // perform action when allow permission success
          } else {
            Toast.makeText(this, "Allow permission for storage access!", Toast.LENGTH_SHORT).show();
          }
        }
        break;
    }
  }

  boolean deleteFileSystemEntity(List<String> list) {
    try {
      for (String path : list) {
        Path filePath = Paths.get(path);
        File file = filePath.toFile();
        System.out.println(file);
        deleteDirectory(file);
        if (!file.canWrite()) {
            requestPermission();
//          Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
//          Uri uri = Uri.fromFile(file);
////          startActivity(intent);
//          getContentResolver().takePersistableUriPermission(uri,
//              // Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION,
//              Intent.FLAG_GRANT_WRITE_URI_PERMISSION | Intent.FLAG_GRANT_READ_URI_PERMISSION);
          deleteDirectory(file);
        }
      }
      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }

  }

  public boolean deleteDirectory(File file) {

    if (file.exists()) {
      if (file.isDirectory()) {
        File[] files = file.listFiles();
        for (File value : files) {
          if (value.isDirectory()) {
           return deleteDirectory(value);
          } else {

           final boolean result = value.delete();
            System.out.println(value + "Deleted" + result);
           return result;
          }
        }
      }
     return file.delete();
    }
    return false;
  }

}