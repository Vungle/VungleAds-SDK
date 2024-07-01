package com.vungle.samples.samplejava.ui.fragment;


import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.navigation.fragment.NavHostFragment;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.RecyclerView;

import com.vungle.ads.InitializationListener;
import com.vungle.ads.VungleAds;
import com.vungle.ads.VungleError;
import com.vungle.samples.samplejava.R;
import com.vungle.samples.samplejava.databinding.FragmentPlacementBinding;
import com.vungle.samples.samplejava.ui.PlacementAdapter;

import java.util.ArrayList;
import java.util.List;

public class PlacementFragment extends Fragment {
    private static final String TAG = PlacementFragment.class.getSimpleName();
    private static final String APP_ID = "643d1db1143d3bfd6bcf6510";
    private static final String INTERSTITIAL_PLACEMENT = "INTERSTITIAL_NON_BIDDING-5048200";
    private static final String REWARD_PLACEMENT = "REWARDED_VIDEO_NON_BIDDING-0010836";
    private static final String MREC_PLACEMENT = "MREC_NON_BIDDING-4205088";
    private static final String BANNER_PLACEMENT = "BANNER_NON_BIDDING-4570799";
    private static final String NATIVE_PLACEMENT = "NATIVE_NON_BIDDING-7989926";
    private static final String APPOPEN_PLACEMENT = "APPOPEN_NON_BIDDING-0475560";
    private static final String INLINE_PLACEMENT = "";//TODO

    FragmentPlacementBinding binding = null;

    private boolean isSDKInitialized = false;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        binding = FragmentPlacementBinding.inflate(inflater, container, false);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        TextView lbSDKVersion = binding.getRoot().findViewById(R.id.lbSdkVersion);
        lbSDKVersion.setText(VungleAds.getSdkVersion());

        RecyclerView recyclerView = binding.tblPlacementList;
        recyclerView.addItemDecoration(new DividerItemDecoration(requireActivity(), DividerItemDecoration.VERTICAL));

        List<PlacementAdapter.Item> itemList = new ArrayList<>();
        itemList.add(new PlacementAdapter.Item("Interstitial", INTERSTITIAL_PLACEMENT));
        itemList.add(new PlacementAdapter.Item("Rewarded Video", REWARD_PLACEMENT));
        itemList.add(new PlacementAdapter.Item("MREC", MREC_PLACEMENT));
        itemList.add(new PlacementAdapter.Item("Banner", BANNER_PLACEMENT));
        itemList.add(new PlacementAdapter.Item("Native", NATIVE_PLACEMENT));
        itemList.add(new PlacementAdapter.Item("Appopen", APPOPEN_PLACEMENT));
        itemList.add(new PlacementAdapter.Item("Inline", INLINE_PLACEMENT));

        if (!VungleAds.isInitialized()) {
            VungleAds.init(requireActivity(), APP_ID, new InitializationListener() {
                @Override
                public void onSuccess() {
                    isSDKInitialized = true;
                    Log.d(TAG, "Vungle SDK init onSuccess()");
                    Toast.makeText(requireActivity(), "Vungle SDK init onSuccess()", Toast.LENGTH_LONG).show();
                }

                @Override
                public void onError(@NonNull VungleError vungleError) {
                    Log.d(TAG, "onError():" + vungleError.getErrorMessage());
                    Toast.makeText(requireActivity(), "Vungle SDK init fail: " + vungleError.getErrorMessage(), Toast.LENGTH_LONG).show();

                }
            });
        }


        PlacementAdapter adapter = new PlacementAdapter(itemList);
        adapter.setOnItemClickListener(position -> {
            if (!isSDKInitialized) {
                Toast.makeText(requireActivity(), "Vungle SDK is not initialized.", Toast.LENGTH_LONG).show();
                return;
            }

            PlacementAdapter.Item item = itemList.get(position);
            int destination;
            switch (item.getPlacementType()) {
                case "Interstitial":
                default:
                    destination = R.id.action_nav_placement_list_to_nav_interstitial;
                    break;
                case "Rewarded Video":
                    destination = R.id.action_nav_placement_list_to_nav_rewarded;
                    break;
                case "Banner":
                    destination = R.id.action_nav_placement_list_to_nav_banner;
                    break;
                case "MREC":
                    destination = R.id.action_nav_placement_list_to_nav_mrec;
                    break;
                case "Native":
                    destination = R.id.action_nav_placement_list_to_nav_nativead;
                    break;
                case "Appopen":
                    destination = R.id.action_nav_placement_list_to_nav_appopenad;
                    break;
                case "Inline":
                    destination = R.id.action_nav_placement_list_to_nav_inlinead;
                    break;

            }
            Bundle bundle = new Bundle();
            bundle.putString("placement_id", item.getPlacementId());

            NavHostFragment.findNavController(PlacementFragment.this).navigate(destination, bundle);

        });
        recyclerView.setAdapter(adapter);

    }

}
