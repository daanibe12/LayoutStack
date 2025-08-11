// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
public struct LayoutHStack: Layout {
    var alignment: VerticalAlignment = .center
    var spacing: CGFloat? = nil
    
    private func sumOfWeights(subviews: Subviews) -> CGFloat {
        subviews.reduce(0) { $0 + ($1[WeightLayoutValue.self]) }
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews,
                      cache: inout ()) -> CGSize {
        let totalWeight = sumOfWeights(subviews: subviews)
        let resolvedSpacing = spacing ?? (subviews.isEmpty ? 0 : 8)
        let totalSpacing = resolvedSpacing * CGFloat(subviews.count - 1)
        
        let subviewProposal = ProposedViewSize(width: nil, height:
                                                proposal.height)
        
        var maxDimension: CGFloat = 0
        if let totalProposalDimension = proposal.width {
            let availableDimension = totalProposalDimension - totalSpacing
            maxDimension = availableDimension
        } else {
            maxDimension = subviews.reduce(0) {
                let subviewWeight = $1[WeightLayoutValue.self]
                let subviewDimension = $1.sizeThatFits(subviewProposal).width
                return max($0, subviewDimension / subviewWeight * totalWeight)
            }
        }
        
        let calculatedDimension = maxDimension + totalSpacing
        
        let height = proposal.height ?? subviews.map {
            $0.sizeThatFits(subviewProposal).height }.max() ?? 0
        return CGSize(width: calculatedDimension, height: height)
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize,
                       subviews: Subviews, cache: inout ()) {
        let totalWeight = sumOfWeights(subviews: subviews)
        let resolvedSpacing = spacing ?? (subviews.isEmpty ? 0 : 8)
        let totalSpacing = resolvedSpacing * CGFloat(subviews.count - 1)
        
        let availableDimension = bounds.width - totalSpacing
        var offset: CGFloat = bounds.minX
        
        for subview in subviews {
            let weight = subview[WeightLayoutValue.self]
            let subviewDimension = availableDimension * (weight / totalWeight)
            
            let subviewProposal = ProposedViewSize(width:
                                                    subviewDimension, height: proposal.height)
            let subviewSize = subview.sizeThatFits(subviewProposal)
            
            let placementPoint: CGPoint
            let y = alignment.dimension(in: bounds, subview: subviewSize)
            placementPoint = CGPoint(x: offset, y: y)
            offset += subviewDimension + resolvedSpacing
            
            subview.place(at: placementPoint, proposal: subviewProposal)
        }
    }
    
    struct WeightLayoutValue: LayoutValueKey {
        static let defaultValue: CGFloat = 0
    }
}

extension HorizontalAlignment {
    func dimension(in bounds: CGRect, subview: CGSize) -> CGFloat {
        switch self {
        case .leading: return bounds.minX
        case .trailing: return bounds.maxX - subview.width
        case .center: return bounds.midX - subview.width / 2
        default: return bounds.minX
        }
    }
}

extension VerticalAlignment {
    func dimension(in bounds: CGRect, subview: CGSize) -> CGFloat {
        switch self {
        case .top: return bounds.minY
        case .bottom: return bounds.maxY - subview.height
        case .center: return bounds.midY - subview.height / 2
        default: return bounds.minY
        }
    }
}

extension View {
    func weightV(_ weight: CGFloat) -> some View {
        layoutValue(key: LayoutVStack.WeightLayoutValue.self, value: weight)
    }

    func weightH(_ weight: CGFloat) -> some View {
        layoutValue(key: LayoutHStack.WeightLayoutValue.self, value: weight)
    }
}


public struct LayoutVStack: Layout {
    var alignment: HorizontalAlignment = .center
    var spacing: CGFloat? = nil
    
    private func sumOfWeights(subviews: Subviews) -> CGFloat {
        subviews.reduce(0) { $0 + ($1[WeightLayoutValue.self]) }
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews,
                      cache: inout ()) -> CGSize {
        let totalWeight = sumOfWeights(subviews: subviews)
        let resolvedSpacing = spacing ?? (subviews.isEmpty ? 0 : 10)
        let totalSpacing = resolvedSpacing * CGFloat(subviews.count - 1)
        
        let subviewProposal = ProposedViewSize(width: proposal.width,
                                               height: nil)
        
        var maxDimension: CGFloat = 0
        if let totalProposalDimension = proposal.height {
            let availableDimension = totalProposalDimension - totalSpacing
            maxDimension = availableDimension
        } else {
            maxDimension = subviews.reduce(0) {
                let subviewWeight = $1[WeightLayoutValue.self]
                let subviewDimension = $1.sizeThatFits(subviewProposal).height
                return max($0, subviewDimension / subviewWeight * totalWeight)
            }
        }
        
        let calculatedDimension = maxDimension + totalSpacing
        
        let width = proposal.width ?? subviews.map {
            $0.sizeThatFits(subviewProposal).width }.max() ?? 0
        return CGSize(width: width, height: calculatedDimension)
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize,
                       subviews: Subviews, cache: inout ()) {
        let totalWeight = sumOfWeights(subviews: subviews)
        let resolvedSpacing = spacing ?? (subviews.isEmpty ? 0 : 10)
        let totalSpacing = resolvedSpacing * CGFloat(subviews.count - 1)
        
        let availableDimension = bounds.height - totalSpacing
        var offset: CGFloat = bounds.minY
            
        for subview in subviews {
            let weight = subview[WeightLayoutValue.self]
            let subviewDimension = availableDimension * (weight / totalWeight)
            
            let subviewProposal = ProposedViewSize(width:
                                                    proposal.width, height: subviewDimension)
            let subviewSize = subview.sizeThatFits(subviewProposal)
            
            let placementPoint: CGPoint
            let x = alignment.dimension(in: bounds, subview: subviewSize)
            placementPoint = CGPoint(x: x, y: offset)
            offset += subviewDimension + resolvedSpacing
            
            subview.place(at: placementPoint, proposal: subviewProposal)
        }
    }
    
    struct WeightLayoutValue: LayoutValueKey {
        static let defaultValue: CGFloat = 0
    }
}

