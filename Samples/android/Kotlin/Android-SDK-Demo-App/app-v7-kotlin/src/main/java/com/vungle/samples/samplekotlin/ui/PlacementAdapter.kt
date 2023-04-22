package com.vungle.samples.samplekotlin.ui

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.vungle.samples.samplekotlin.R

class PlacementAdapter(
    private val adItemList: MutableList<Item>,
    private val listener: (Item) -> Unit
) : RecyclerView.Adapter<PlacementAdapter.ViewHolder>() {

    inner class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val tvAdType: TextView
        val tvPlacementId: TextView

        init {
            tvAdType = view.findViewById(R.id.lb_placement_type)
            tvPlacementId = view.findViewById(R.id.lb_placement_id)
        }
    }

    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(viewGroup.context)
            .inflate(R.layout.placement_item, viewGroup, false)

        return ViewHolder(view)
    }

    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {
        val adItem = adItemList[position]
        viewHolder.tvAdType.text = adItem.placementType
        viewHolder.tvPlacementId.text = adItem.placementId
        viewHolder.itemView.setOnClickListener { listener(adItem) }
    }

    override fun getItemCount(): Int {
        return adItemList.size
    }

    class Item(val placementType: String, val placementId: String)

}