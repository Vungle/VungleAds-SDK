package com.vungle.samples.samplejava.ui.fragment.feed;

import android.content.Context;
import android.util.Log;
import com.vungle.samples.samplejava.R;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import org.json.JSONArray;
import org.json.JSONObject;

public class CommonSampleData {

  private final String name;
  private final String menuItemDescription;
  private final String menuItemPrice;
  private final String menuItemCategory;

  public CommonSampleData(String name, String menuItemDescription, String menuItemPrice,
      String menuItemCategory) {
    this.name = name;
    this.menuItemDescription = menuItemDescription;
    this.menuItemPrice = menuItemPrice;
    this.menuItemCategory = menuItemCategory;
  }

  public String getName() {
    return name;
  }

  public String getMenuItemDescription() {
    return menuItemDescription;
  }

  public String getMenuItemPrice() {
    return menuItemPrice;
  }

  public String getMenuItemCategory() {
    return menuItemCategory;
  }

  public static ArrayList<CommonSampleData> createDemoDataList(Context context) {
    ArrayList<CommonSampleData> demoDataList = new ArrayList<>();
    try {
      String jsonDataString = readJsonDataFromFile( context );
      JSONArray menuItemsJsonArray = new JSONArray( jsonDataString );
      for (int i = 0; i < menuItemsJsonArray.length(); i++) {
        JSONObject menuItemObject = menuItemsJsonArray.getJSONObject( i );
        String menuItemName = menuItemObject.getString( "name" );
        String menuItemDescription = menuItemObject.getString( "description" );
        String menuItemPrice = menuItemObject.getString( "price" );
        String menuItemCategory = menuItemObject.getString( "category" );
        CommonSampleData menuItem = new CommonSampleData(
            menuItemName, menuItemDescription, menuItemPrice,
            menuItemCategory
        );
        demoDataList.add( menuItem );
      }
    } catch (Exception ex) {
      Log.e( "CommonSampleData", "Unable to parse JSON file.", ex );
    }
    return demoDataList;
  }

  private static String readJsonDataFromFile(Context context) throws IOException {
    StringBuilder builder = new StringBuilder();
    InputStream inputStream = null;
    try {
      String jsonDataString;
      inputStream = context.getResources().openRawResource( R.raw.sample_data_json );
      BufferedReader bufferedReader = new BufferedReader(
          new InputStreamReader( inputStream ) );
      while ((jsonDataString = bufferedReader.readLine()) != null) {
        builder.append( jsonDataString );
      }
    } finally {
      if (inputStream != null) {
        inputStream.close();
      }
    }
    return new String( builder );
  }
}
