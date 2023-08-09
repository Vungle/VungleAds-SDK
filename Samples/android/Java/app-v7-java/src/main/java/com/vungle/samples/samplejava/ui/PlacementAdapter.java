package com.vungle.samples.samplejava.ui;

import android.annotation.SuppressLint;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.vungle.samples.samplejava.R;

import java.util.List;

public class PlacementAdapter extends RecyclerView.Adapter<PlacementAdapter.ViewHolder> {
    private List<Item> mData;
    private OnItemClickListener listener;

    public PlacementAdapter(List<Item> data) {
        mData = data;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(
                R.layout.placement_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, @SuppressLint("RecyclerView") final int position) {
        Item item = mData.get(position);
        holder.tvPlacementType.setText(item.getPlacementType());
        holder.tvPlacementId.setText(item.getPlacementId());
        holder.itemView.setOnClickListener(v -> {
            if (listener != null) {
                Log.e("click", "!");
                listener.onItemClick(position);
            }
        });
    }

    @Override
    public int getItemCount() {
        return mData.size();
    }

    public void setOnItemClickListener(OnItemClickListener listenser) {
        this.listener = listenser;
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        public TextView tvPlacementType;
        public TextView tvPlacementId;

        public ViewHolder(View itemView) {
            super(itemView);

            tvPlacementType = itemView.findViewById(R.id.lb_placement_type);
            tvPlacementId = itemView.findViewById(R.id.lb_placement_id);
        }
    }

    public static class Item {
        private String placementType;
        private String placementId;

        public Item(String type, String id) {
            this.placementType = type;
            this.placementId = id;
        }

        public String getPlacementType() {
            return placementType;
        }

        public String getPlacementId() {
            return placementId;
        }
    }

    public interface OnItemClickListener {
        void onItemClick(int position);
    }
}
