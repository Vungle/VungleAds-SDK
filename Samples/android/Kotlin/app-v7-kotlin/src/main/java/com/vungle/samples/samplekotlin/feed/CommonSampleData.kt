package com.vungle.samples.samplekotlin.feed

import android.content.Context
import android.util.Log
import com.vungle.samples.samplekotlin.R
import org.json.JSONArray
import java.io.BufferedReader
import java.io.IOException
import java.io.InputStream
import java.io.InputStreamReader

class CommonSampleData private constructor(
    val name: String,
    val description: String,
    val price: String,
    val category: String
) {

    companion object {
        fun createDemoDataList(context: Context): ArrayList<CommonSampleData> {
            val datas = ArrayList<CommonSampleData>()
            try {
                val jsonDataString = readJsonDataFromFile(context)
                val menuItemsJsonArray = JSONArray(jsonDataString)
                for (i in 0 until menuItemsJsonArray.length()) {
                    val menuItemObject = menuItemsJsonArray.getJSONObject(i)
                    val menuItemName = menuItemObject.getString("name")
                    val menuItemDescription = menuItemObject.getString("description")
                    val menuItemPrice = menuItemObject.getString("price")
                    val menuItemCategory = menuItemObject.getString("category")
                    val menuItem = CommonSampleData(
                        menuItemName, menuItemDescription, menuItemPrice,
                        menuItemCategory
                    )
                    datas.add(menuItem)
                }
            } catch (exception: Exception) {
                Log.e("CommonSampleData", "Unable to parse JSON file.", exception)
            }
            return datas
        }

        @Throws(IOException::class)
        private fun readJsonDataFromFile(context: Context): String {
            var inputStream: InputStream? = null
            val builder = StringBuilder()
            try {
                var jsonDataString: String?
                inputStream = context.resources.openRawResource(R.raw.sample_data_json)
                val bufferedReader = BufferedReader(
                    InputStreamReader(inputStream, "UTF-8")
                )
                while (bufferedReader.readLine().also { jsonDataString = it } != null) {
                    builder.append(jsonDataString)
                }
            } finally {
                inputStream?.close()
            }
            return String(builder)
        }
    }
}
